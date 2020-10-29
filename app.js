const express = require('express');
// eslint-disable-next-line no-unused-vars
var hbs = require('express-handlebars');
const rs = require('rocket-store');

const app = express();
const port = 8080;

//Loads the handlebars module
const handlebars = require('express-handlebars');

//Sets our app to use the handlebars engine
app.set('view engine', 'handlebars');

//Sets handlebars configurations (we will go through them later on)
app.engine('handlebars', handlebars({
    // eslint-disable-next-line no-undef
    layoutsDir: __dirname + '/views/layouts',
}));

// eslint-disable-next-line no-undef
app.use(express.static(__dirname + '/public'));

const test = [
    {
        "blog-title": "First",
        "blog-content": "Lorem ipsum",
        "blog-author": "Michael"
    },
    {
        "blog-title": "Second",
        "blog-content": "Lorem ipsum",
        "blog-author": "Vlad"
    },
    {
        "blog-title": "Third",
        "blog-content": "Lorem ipsum",
        "blog-author": "Hank Hill"
    }
];

app.get('/', (req, res) => {
    // Serves the body of the page "main.handlebars" to the container "index.handlebars"
    res.render('main', {layout : 'index', blogs: test, listExists: true});
});

app.listen(port, () => console.log(`App listening to port ${port}`));