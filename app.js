const express = require('express');
// eslint-disable-next-line no-unused-vars
const hbs = require('express-handlebars');
const rs = require('rocket-store');
const bp = require('body-parser');
const fs = require('fs');
const handlebars = require('express-handlebars');

const app = express();
const port = 8080;

// Clear the database
rs.delete("blogs", "*");

//Sets our app to use the handlebars engine
app.set('view engine', 'handlebars');

//Sets handlebars configurations
app.engine('handlebars', handlebars({
    // eslint-disable-next-line no-undef
    layoutsDir: __dirname + '/views/layouts',
}));

// eslint-disable-next-line no-undef
app.use(express.static(__dirname + '/public'));

app.use(bp.urlencoded({ extended: false }));

// parse application/json
app.use(bp.json());

// Use the blog files as initial content
const pathToBlogs = "public/blogfiles/";
fs.readdir(pathToBlogs, function(err, files) {
    files.forEach(function(file) {
        fs.readFile(pathToBlogs + file, 'utf8', function(err, data) {
            if (err) {
                throw err;
            }
            postBlog("ECS Blog", data, "ECS");
        });
    });
});

app.get('/', async (req, res) => {
    // Serves the body of the page "main.handlebars" to the container "index.handlebars"
    try {
        const blogs = await getAllBlogs();
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

app.post('/blogs', (req, res) => {
    postBlog(req.body.title, req.body.content, req.body.author);
    return res.status(200).send("Success");
});

app.post('/blogs/:id', (req, res) => {
    const id = req.params.id;
    updateBlog(id, req.body.title, req.body.content, req.body.author);
    return res.status(200).send("Success");
});

app.delete('/blogs/:id', (req, res) => {
    const id = req.params.id;
    deleteBlog(id);
    return res.status(200).send("Success");
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
    const result = await rs.post("blogs", "blog", {"title": title, "content": content, "author": author}, rs._ADD_AUTO_INC);
}

async function updateBlog(id, title, content, author) {
    const result = await rs.post("blogs", id, {"title": title, "content": content, "author": author});
}

async function deleteBlog(id) {
    const result = await rs.delete("blogs", id);
}

app.listen(port, () => console.log(`App listening to port ${port}`));