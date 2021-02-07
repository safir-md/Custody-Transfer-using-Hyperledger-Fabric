const express = require('express');
const morgan = require('morgan');
const cors = require('cors');
const jwt = require('jsonwebtoken');
const bodyParser = require('body-parser');

const {network_api} = require('../client-application/network-api.js');

const app = express()
const port = 3000

  
app.listen(port, () => {
    console.log(`Example app listening at http://localhost:${port}`)
  });

/*const validateJWT = (req, res, next) => {
    const authHeader = req.headers.authorization;
  
    if (authHeader) {
      const token = authHeader.split(' ')[1];
  
      if (token === '' || token === 'null') {
        return res.status(401).send('Unauthorized request');
      }
  
      jwt.verify(token, 'orgtokenkey', (err, data) => {
        if (err) {
          return res.sendStatus(403);
        }
        req.user = data;
        next();
      });
    } else {
      return res.status(401).send('Unauthorized request');
    }
};*/

app.post('/assets/buy', validateJWT, async (req, res) => {
    res.send('Hello World!')
  });

app.post('/assets/location', validateJWT, async (req, res) => {
    res.send('Hello World!')
  });

app.post('/assets/approve', validateJWT, async (req, res) => {
    res.send('Hello World!')
  });

  app.get('/assets/history', validateJWT, async (req, res) => {
    res.send('Hello World!')
  });

  app.get('/assets/all', validateJWT, async (req, res) => {
    const org_val =  req.headers.org;
    const result = await getAsset(org_val, 'GetAllAssets', false);
    res.send(result);
  });


  
  // TODO: Login to be changed to login/patient and login/doctor
  app.post('/login', async (req, res) => {
    // Read uname and password from request body
    console.log(req.body);
    const { uname, pass} = req.body;
    const org = 'buyer_org';
    let if_user = false;
    switch(org){
        case 'buyer_org':
            if_user = uname === 'buyusr' && pass === 'buypass';
            break;
        case 'seller_org':
            if_user = uname === 'selusr' && pass === 'selpass';
            break;
        case 'tsp_org':
            if_user = uname === 'tspusr' && pass === 'tsppass';
            break;
        case 'buy_gov_org':
            if_user = uname === 'bgvusr' && pass === 'bgvpass';
            break;
        case 'sel_gov_org':
            if_user = uname === 'sgvusr' && pass === 'sgvpass';
            break;
    }

    if (if_user) {
      // Generate an access token
      const accessToken = jwt.sign({org: org, username: uname}, 'orgtokenkey');
      res.status(200);
      res.json({
        accessToken,
      });
    } else {
      res.status(400).send({error: 'uname or password incorrect!'});
    }
  });