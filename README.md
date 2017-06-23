# Extension.JobSchedule
Schedule task in a procedure queue

------------------------------------------------------

		/// <summary>
        /// Adding a Task to a Processing Queue
        /// </summary>
        /// <param name="guid"> Contract Identifier. 
        /// Any adding task in this GUID will be adding in the queue for processing, 
        /// respecting the order of arrival</param>
        /// <param name="taskName">Tasks to run in the contract queue identified by your GUID</param>
        /// <returns></returns>      
        public string AddTask(string guid, string taskName)
        {
            try
            {

                // Create a new contract with a GUID identifier, add a handle to the task that will be executed.
                using (var c = new ContractSchedule(guid, taskName))
                {
                    // Adds an ACTION with delegate to the method that will perform the task
                    c.ActionTask = delegate
                    {
                        // Delegated method receiving parameter with processing status
                        Loading(c.Status);
                    };

                    // Add task in processing queue
                    QueueJob.AddTask(new ScheduledTask(c, c.ActionTask));
                }
                return "true";
            }
            catch (Exception e)
            {                
                return JsonConvert.SerializeObject("false");
            }
        }