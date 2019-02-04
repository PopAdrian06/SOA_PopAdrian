'use strict';

const Koa = require('koa');
const app = new Koa();
const server = require('http').createServer(app.callback());
const WebSocket = require('ws');
const wss = new WebSocket.Server({server});
const Router = require('koa-router');
const cors = require('koa-cors');
const bodyparser = require('koa-bodyparser');

app.use(bodyparser());
app.use(cors());
app.use(async function (ctx, next) {
  const start = new Date();
  await next();
  const ms = new Date() - start;
  console.log(`${ctx.method} ${ctx.url} ${ctx.response.status} - ${ms}ms`);
});

const file_name = 'data.json'

function save(data) {
  var fs = require('fs');
  fs.writeFile(file_name, JSON.stringify(data), 'utf8', function(error) {
    if (error) {
      console.log("save file error: " + `${error}`)
    } else {
      console.log("saved data:\n" + `${JSON.stringify(data)}`)
    }
  });
}

function prepopulate(database) {
  console.log("PREPOPULATING...");
  for (let i = 0; i < 10; i++) {
    database.items.push({id: `${i}`, text: `Item ${i}`, created: Date.now(), updated: Date.now(), completed: 0});
  }
  save(database)
}

// persistency

var database = { items: [] };

// load data from database
var fs = require('fs');
fs.readFile(file_name, 'utf8', function readFileCallback(err, data) {
  if (err) {
    console.log(err);
  } else {
    console.log("GOT DATA:\n" + `${data}`);

    try {
      database = JSON.parse(data);
    } catch (e) {
      console.error("EXCEPTION CAUGHT while reading " +
       `${file_name}` + ":\n" + `${e}`);
      prepopulate(database);
    }
  }
});

// endpoints
const router = new Router();

// get all
router.get('/items', ctx => {
  ctx.response.body = database.items.sort((n1, n2) => -(n1.updated - n2.updated));
  ctx.response.status = 200;
});

// update item
router.put('/item/:id', ctx => {
  const item = ctx.request.body;
  const id = ctx.params.id;

  const index = database.items.findIndex(n => n.id === id);
  if (id !== item.id || index === -1) {
    ctx.response.body = {text: 'Item not found'};
    ctx.response.status = 400;
  } else {
    item.updated = Date.now();
    database.items[index] = item;
    ctx.response.body = item;
    ctx.response.status = 200;
    save(database)
  }
});


app.use(router.routes());
app.use(router.allowedMethods());

server.listen(3000);
