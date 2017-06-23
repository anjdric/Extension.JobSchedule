<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TarefaStatus.aspx.cs" Inherits="Extension.WebForm.Teste.TarefaStatus" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Processamento de Tarefas</title>
    <link href="Content/bootstrap.min.css" rel="stylesheet" />
    <link href="Content/bootstrap-theme.min.css" rel="stylesheet" />
    <script src="Scripts/jquery-2.2.4.min.js"></script>
    <script src="Scripts/jquery-2.2.4.intellisense.js"></script>
    <script type="text/javascript">

        $(document).ready(function () {
            startup();
            setStart;
        });

        $(document).on('click', '.btn-primary', function () {
            Selection_Proxy.GettHttpGet(".progress-bar-primary", "A", successCallback, failureCallback);
        });
        $(document).on('click', '.btn-warning', function () {
            Selection_Proxy.GettHttpGet(".progress-bar-warning", "B", successCallback, failureCallback);
        });
        $(document).on('click', '.btn-danger', function () {
            Selection_Proxy.GettHttpGet(".progress-bar-danger", "C", successCallback, failureCallback);
        });

        function Selection_Proxy() { }
        Selection_Proxy.GettHttpGet = function (guid, taskName, successCallback, failureCallback) {
            $.ajax({
                type: "GET",
                async: true,
                contentType: "application/json; charset=utf-8",
                url: "TarefaStatus.aspx/StartTask?guid='" + guid + "'&taskName='" + taskName + "'",
                success: function (data) {
                    successCallback(data);
                },
                error: function (data) {
                    failureCallback(data);
                }
            });
        };
        function Status_Proxy() { }
        Status_Proxy.GettHttpGet = function (guid, taskName) {
            $.ajax({
                type: "GET",
                async: true,
                contentType: "application/json; charset=utf-8",
                url: "StatusProcess.ashx?guid=" + guid + "&taskName=" + taskName,
                success: function (data) {
                    var perc = parseInt(data.PercComplet * 100);
                    if (perc !== 100) {
                        $(guid).width((data.PercComplet * 100) + "%").html(perc + "%");
                    } else if (perc === 100) {
                        $(guid).width("100%").html("100%");
                    }
                },
                error: function (data) {
                    //console.log("erro " + data.d);
                    failureCallback(data);
                }
            });
        };

        var successCallback = function (data) {
            console.log("sucesso " + data.d);
            //var response = eval(data.d);
            // console.log(response);
        }
        var failureCallback = function (data) {
            clearInterval(setStart);
            // console.log("erro " + data.d)          
        }
        var startup = function () {
            Status_Proxy.GettHttpGet(".progress-bar-primary", "A");
            Status_Proxy.GettHttpGet(".progress-bar-warning", "B");
            Status_Proxy.GettHttpGet(".progress-bar-danger", "C");
        };
        var setStart = setInterval(function () {
            startup();
        }, 3500);
    </script>
</head>
<body class="container">

    <div class="container-fluid">
        <div class="row">
            <h2>Testando tarefa</h2>
        </div>
        <div class="row">
            <div class="col-md-12">
                <hr />
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <span class="col-md-2">
                    <button type="button" class="btn btn-primary">Start Tarefa A</button>
                </span>
                <span class="col-md-2">
                    <button type="button" class="btn btn-warning">Start Tarefa B</button>
                </span>
                <span class="col-md-2">
                    <button type="button" class="btn btn-danger">Start Tarefa C</button>
                </span>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <hr />
            </div>
        </div>

        <div class="row">
            <div class="progress">
                <div class="progress-bar progress-bar-primary" role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100" style="width: 0%;">
                </div>
            </div>
        </div>
        <div class="row">
            <div class="progress">
                <div class="progress-bar progress-bar-warning" role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100" style="width: 0%;">
                    <label>0</label>%
                </div>
            </div>
        </div>
        <div class="row">
            <div class="progress">
                <div class="progress-bar progress-bar-danger" role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100" style="width: 0%;">
                    <label>0</label>%
                </div>
            </div>
        </div>


    </div>

</body>
</html>
