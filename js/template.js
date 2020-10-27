function appendBlogEntryToElement(parent) {
    // compile the template
    console.log("test");
    var template = Handlebars.compile(
        "<div class='flex-center position-ref full-height'>\
        <div class='container-lg'>\
        </div>\
            <div>\
                <h1>ECS Blog</h1>\
                <br>\
                <h2>{{blog_header}}</h2>\
                <br>\
                <p>{{blog_content}}</p>\
                <span>{{blog_author}}</span>\
            </div>\
        </div>"
    );
    // execute the compiled template and print the output to the console
    document.getElementsByClassName(parent).appendChild(template({ blog_header: "rocks!" }));
}