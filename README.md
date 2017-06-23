# Extension.JobSchedule
Schedule task in a procedure queue

------------------------------------------------------
        ###############################
        ## Example: TarefaStatus.aspx #
		###############################
		
        /// <summary>
        /// Adding a Task to a Processing Queue
        /// </summary>
        /// <param name="guid"> Contract Identifier. 
        /// Any adding task in this GUID will be adding in the queue for processing, 
        /// respecting the order of arrival</param>
        /// <param name="taskName">Tasks to run in the contract queue identified by your GUID</param>
        /// <returns></returns>
        [WebMethod]
        [ScriptMethod(UseHttpGet = true, ResponseFormat = ResponseFormat.Json, XmlSerializeString = false)]
        public static string StartTask(string guid, string taskName)
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
                Console.WriteLine(e);
                return JsonConvert.SerializeObject("false");
            }
        }
		
------------------------------------------------------
        ################################
        ## Example: StatusProcess.ashx #
		################################		
		
    /// <summary>
    /// Summary description for StatusProcess
    /// Tracking processing status of a task through 
    /// the contract identifier GUID and task name
    /// </summary>
    public class StatusProcess : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/json";
            var callback = context.Request.QueryString["callback"];

            if (context.Request.QueryString["guid"] == null || context.Request.QueryString["taskName"] == null)
                return;

            var json = this.GetCustomersJSON(context.Request.QueryString["guid"], context.Request.QueryString["taskName"]);

            if (!string.IsNullOrEmpty(callback))
                json = $"{callback}({json})";

            context.Response.Write(json);
        }

        /// <summary>
        /// Queries processing status of a task through its GUID and name
        /// </summary>
        /// <param name="customerGuid">Identify the linked contract tasks</param>
        /// <param name="customerTaskName">Name of the task you want to get processing status</param>
        /// <returns></returns>
        private string GetCustomersJSON(string customerGuid, string customerTaskName)
        {
            // Gets contract processing status
            var stt = QueueJob.ProcessStatus(customerGuid, customerTaskName);
            return JsonConvert.SerializeObject(stt);
        }
        public bool IsReusable => true;
    }

	
	------------------------------------------------------
        ################################
        ## Example: StatusProcess.ashx #
		################################		
		
		

