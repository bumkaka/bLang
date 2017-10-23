<div id="container"></div>



<script>

    function add_row() {
        var values = $$("form_add").getValues();
        $.post('[+moduleurl+]action=save',values,function () {
            $$("data").loadNext(-1,0);
            $$('form_add').clear();
        })
    }
    function removeData(id) {
        webix.confirm({
            title: "Удалить",// the text of the box header
            text: "Вы уверенны что хотите удалить?",
            callback: function(result) {
                if (result) {
                    $$("data").remove(id);
                }
            }
        });

    }
    function my_translate(id) {
        var dataTable = $$("data");
        var record = dataTable.getItem(id);
        $.post('[+moduleurl+]action=translate',record,function (elem) {

            dataTable.updateItem(id, elem);
        })
    }
    var form1 = [
        {view: "text", name: "name",  label: "Название"},
        {view: "text",  name: "title", label: "Заголовок"},
        [+lang_input+]

        {
            margin: 5, cols: [
            {view: "button", click: "add_row", value: "Добавить", type: "form"},

        ]
        }
    ];


    webix.ui({
            container: "container",
            cols: [
                {
                    rows: [{
                        view: "datatable",
                        id: "data",
                        columns: [

                            {id: "name", editor: "text", name: "name", header: "Название"},
                            {id: "title", editor: "text", name: "title", header: "Заголовок"},
                            [+lang_columns+]
                            { id:"id", header:["<center><a style='margin-top:10px ' class='deleteButton btnSmall webix_icon fa-close'></a></center>"], template:"<center><a class='deleteButton btnSmall webix_icon fa-close' onclick='removeData(#id#)'></a></center>", width:50},
                            { id:"id", header:["<a class='webix_icon fa-globe'></a>"], template:"<a class='webix_icon fa-globe' onclick='my_translate(#id#)'></a>", width:50}

                        ],
                        editable: true,
                        autoheight: true,

                        url: "[+moduleurl+]action=getData",
                        save: "[+moduleurl+]action=save"
                    },
                        { view:"form", id: "form_add",  elements: form1 },
                    ]
                },

            ]
        }
    );



    $(document).on('click', '#add', function () {

    })
</script>