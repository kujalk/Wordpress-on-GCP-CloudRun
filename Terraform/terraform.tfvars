project-id         = "tf-project-0123"
prefix             = "wordprex" # Make sure this not exceed 12 characters
min_instance_count = 1
max_instance_count = 5
max_cpu            = "1000m" #https://cloud.google.com/run/docs/configuring/memory-limits#terraform
max_memory         = "512Mi" #https://cloud.google.com/run/docs/configuring/memory-limits#terraform
max_concurrency    = "1000"  #https://cloud.google.com/run/docs/about-concurrency