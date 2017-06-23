using Newtonsoft.Json;
using System;
using System.Threading;
using System.Web.Script.Services;
using System.Web.Services;
using Extension.JobSchedule.pcpl._4._5._2;

namespace Extension.WebForm.Teste
{
    public partial class TarefaStatus : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

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

        private static void Loading(Status status)
        {
            var ultimaLinha = new Random().Next(4, 100);
            for (int i = 0; i < ultimaLinha; i++)
            {
                status.PercComplet = (float)i / (float)ultimaLinha;
                Thread.Sleep(1000);
            }
        }
    }
}