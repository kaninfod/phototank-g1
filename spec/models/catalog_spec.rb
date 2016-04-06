
describe Catalog, :type => :model do
  before do
    ResqueSpec.reset!
  end

  after do
    FileUtils.rm_rf(File.join(Rails.root, "spec/test_files/target/"))
  end

  it "creates a master catalog" do
    expect(create(:master_catalog)).to be_valid
  end

  it "creates a local catelog" do
    expect(create(:local_catalog)).to be_valid
  end

  it "adds import job to the resque queue" do
      catalog = create(:master_catalog)
      catalog.import
      catalog.watch_path.each do |p|
        expect(MasterSpawnImportJob).to have_queued(p, nil, false).in(:import)
      end
  end

  it "imports a photo to master catalog" do
    import_path = [File.join(Rails.root, '/spec/test_files/store/one_jpeg/')]
    catalog = create(
      :master_catalog,
      :watch_path => import_path
      )

    expect {
      with_resque do
        catalog.import
      end
    }.to change {catalog.photos.count}.by(1)

  end


  it "that a catalog can be created and deleted" do
    #create new master
    master_catalog = Catalog.new(
      type:"MasterCatalog",
      name:"master",
      default:true,
      import_mode: false,
      watch_path: [File.join(Rails.root, '/spec/test_files/store/3_jpegs/')],
      path: File.join(Rails.root, "test/test_files/store/master")
       )
    expect {
      master_catalog.save
    }.to change {Catalog.count}.by(1)

    expect {
      with_resque do
        master_catalog.import
      end
    }.to change {master_catalog.photos.count}.by(3)


    master_catalog.photos.each do |photo|
      expect(File.exist?(photo.absolutepath)).to be true
    end

    #create local
    local_catalog = Catalog.new(
      type:"LocalCatalog",
      name:"Local-catalog-clone",
      sync_from_catalog: master_catalog.id,
      path: File.join(Rails.root, "test/test_files/store/local")
      )

      expect {
        local_catalog.save
      }.to change {Catalog.count}.by(1)


    #clone local from master
    expect {
      with_resque do
        local_catalog.import
      end
    }.to change {local_catalog.photos.count}.by(3)

    files = []
    local_catalog.photos.each do |photo|
      files.push(photo.absolutepath(local_catalog.id))
      expect(File.exist?(photo.absolutepath(local_catalog.id))).to be true
    end

    expect {
      local_catalog.destroy
    }.to change {Instance.count}.by(-3)



    files.each do |path|
      expect(File.exist?(path)).to be false
    end
  end

  it "that a photo with no exif date can be imported and get new date" do
    import_path = [File.join(Rails.root, '/spec/test_files/store/no_exif_jpeg')]
    catalog = create(
      :master_catalog,
      :watch_path => import_path
      )
    photo_id=0
    import_path = File.join(import_path, "1460659285661503007.jpg")
    expect {
      with_resque do
        photo_id = catalog.import_photo import_path, nil, false
      end
    }.to change {catalog.photos.count}.by(1)

    photo = Photo.find(photo_id)
    exif = MiniExiftool.new(photo.absolutepath, opts={:numerical=>true})

    date1 = Photo.find(photo_id).date_taken
    date2 = File.ctime(import_path)
    date3 = exif.datetimeoriginal

    expect(date1 == date2).to be true
    expect(date1 == date3).to be true

  end

  it "can delete photo" do


    catalog = create(
      :master_catalog,
      )


    photo_id=0
    import_path = File.join(Rails.root, '/spec/test_files/store/one_jpeg', 'IMG_20160215_143200.jpg')
    c1 = catalog.photos.count

    expect {
      with_resque do
        photo_id = catalog.import_photo import_path, nil, false
      end
    }.to change {catalog.photos.count}.by(1)

    photo = Photo.find(photo_id)
    path1 = photo.absolutepath
    path2 = photo.large_filename
    path3 = photo.medium_filename
    path4 = photo.small_filename

    expect(File.exist?(path1)).to be true
    expect(File.exist?(path2)).to be true
    expect(File.exist?(path3)).to be true
    expect(File.exist?(path4)).to be true

    c2 = catalog.photos.count

    catalog.delete_photo(photo_id)

    expect(File.exist?(path1)).to be false
    expect(File.exist?(path2)).to be false
    expect(File.exist?(path3)).to be false
    expect(File.exist?(path4)).to be false

    c3 = catalog.photos.count

    expect(c1+1).to eq(c2)
    expect(c1).to eq(c3)

  end


end
