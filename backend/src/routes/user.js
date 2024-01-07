const { Router } = require('express');
const router = Router();

const mysqlConnection = require('../database/database.js');

router.get('/', (req, res) => {
    res.status(200).json('Server on port 80 and Database is connected.');
});

router.get('/:users', (req, res) => {
    mysqlConnection.query('select * from user', (error, rows, fields) => {
        if(!error) {
            res.json(rows);
        } else {
            console.log(error);
        }
    });
});

router.get('/:users/:id', (req, res) => {
    const { id } = req.params;
    mysqlConnection.query('select * from user where id = ?', [id], (error, rows, fields) => {
        if(!error) {
            res.json(rows);
        } else {
            console.log(error);
        }
    })
});

router.post('/:users', (req, res) => {
    const { id, username, name, email, password } = req.body;
    console.log(req.body);
    mysqlConnection.query('insert into user(id, username, name, email, password) values (?, ?, ?, ?, ?)', [ id, username, name, email, password], (error, rows, fields) => {
        if(!error) {
            res.json({Status : "User saved"})
        } else {
            console.log(error);
        }
    });
})

router.put('/:users/:id', (req, res) => {
    const { id, username, name, email, password} = req.body;
    console.log(req.body);
    mysqlConnection.query('update user set username = ?, name = ?, email = ?, password where id = ?;', 
    [username, name, email, password, id], (error, rows, fields) => {
        if(!error){
            res.json({
                Status: 'User updated'
            });
        } else {
            console.log(error);
        }
    });
});

router.delete('/:users/:id', (req,res) => {
    const { id } = req.params;
    mysqlConnection.query('delete from user where id = ?', [id], (error, rows, fields) => {
        if(!error){
            res.json({
                Status: "User deleted"
            });
        } else {
            res.json({
                Status: error
            });
        }
    })
});

module.exports = router;

// {
// 	"username": "yeongjae",
//     "name": "kong7300",
//     "email": "kong7300@naver.com",
//     "password": "1234"
// }