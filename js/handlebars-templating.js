function appendBlogEntryToElementById(parent, header, content, author) {
    // Use Handlebars to "compile" the HTML
    let template = Handlebars.compile(
        "<div class='card'>\
            <div class='card-body'>\
                <h5 class='card-title'>\{{blog_header}}</h5>\
                <p class='card-content'>{{blog_content}}</p>\
                <blockquote class='blockquote mb-0'>\
                    <footer class='blockquote-footer'>\
                        <small class='text-muted'>{{blog_author}}</small>\
                    </footer>\
                </blockquote>\
            </div>\
        </div>"
    );
    // Then we give a JSON object with key -> values where keys correspond to
    // the {{ ... }} templating we defined above
    let blog_elements = {
        blog_header: isStringEmpty(header) ? "Foo" : header,
        blog_content: isStringEmpty(content) ? "Lorem Ipsum" : content,
        blog_author: isStringEmpty(author) ? "Bar" : author
    }
    document.getElementById(parent).appendChild(htmlToElement(template(blog_elements)));
}

function htmlToElement(html) {
    let template = document.createElement('template');
    html = html.trim();
    template.innerHTML = html;
    return template.content.firstChild;
}

function isStringEmpty(str) {
    if (typeof str === 'undefined' || typeof str === null) {
        return true;
    }

    if (str.trim() === "") {
        return true;
    }

    return false;
}