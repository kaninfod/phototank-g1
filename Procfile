photoserve:              cd ../photoserve/ && rails server -p 5001
phototank:               rails server -p 5000
Resque_worker_utility:   bundle exec rake environment resque:work QUEUE=utility TERM_CHILD=1
Resque_worker_import:    bundle exec rake environment resque:work QUEUE=import TERM_CHILD=1
Resque_Scheduler:        rake resque:scheduler
