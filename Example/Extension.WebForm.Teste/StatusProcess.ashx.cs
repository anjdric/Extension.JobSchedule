using Newtonsoft.Json;
using System.Web;
using Extension.JobSchedule.pcpl._4._5._2;


namespace Extension.WebForm.Teste
{
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

}