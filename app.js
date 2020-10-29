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

app.get('/', async (req, res) => {
    // Serves the body of the page "main.handlebars" to the container "index.handlebars"
    try {
        const blogs = await getAllBlogs();
        console.log(JSON.stringify(blogs.result));
        res.render('main', {layout : 'index', blogs: blogs.result, listExists: true});
    } catch (err) {
        // Shouldn't happen
        console.log(err);
        return res.status(550).json(err);
    }
});

// Simple API
app.get('/blogs', async (req, res) => {
    // Return all blogs
    try {
        const blogs = await getAllBlogs();
        return res.status(200).send(JSON.stringify(blogs));
    } catch (err) {
        // Shouldn't happen
        console.log(err);
        return res.status(550).json(err);
    }
});

app.get('/blogs/:id', async (req, res) => {
    // Return a specific blog
    const id = req.params.id;

    try {
        const blog = await getBlog(id);

        if (typeof blog !== undefined) {
            return res.status(200).send(JSON.stringify(blog));
        }

        // Sending 404 when not found something is a good practice
        res.status(404).send('Blog not found');
    } catch (err) {
        // Shouldn't happen
        console.log(err);
        return res.status(550).json(err);
    }
});

app.post('/blog', (req, res) => {
    postBlog(req.body.title, req.body.content, req.body.author);
});

app.post('/blog/:id', (req, res) => {
    const id = req.params.id;
    updateBlog(id, req.body.title, req.body.content, req.body.author);
});

async function getBlog(id) {
    const result = await rs.get("blogs", id);
    return result;
}

async function getAllBlogs() {
    const result = await rs.get("blogs", "*");
    return result;
}

async function postBlog(title, content, author) {
    const result = await rs.post("blogs", "blog", {"blog-title": title, "blog-content": content, "blog-author": author}, rs._ADD_AUTO_INC);
    console.log(result);
}

async function updateBlog(id, title, content, author) {
    const result = await rs.post("blogs", "blog", {"blog-title": title, "blog-content": content, "blog-author": author}, rs._ADD_AUTO_INC);
    console.log(result);
}


app.listen(port, () => console.log(`App listening to port ${port}`));