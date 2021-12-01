const express = require('express');
const router = express.Router();
const multer = require('multer');
const path = require('path');

const  storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, path.resolve(__dirname,'C:'))
    },
    filename: function (req, file, cb) {
        cb(null, file.originalname);
        
    }
})
const  storage1 = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, path.resolve(__dirname,'C:'))
    },
    filename: function (req, file, cb) {
        cb(null, file.originalname);
        
    }
})

const upload = multer({
    storage: storage
})

const upload1 = multer({
    storage: storage1
})

router.post('/file', upload1.single('file'), (req, res) => {
    const Filename = req.file.originalname
    res.send({
        msg:'上传成功',
        Filename
    })
    
})

router.post('/code', upload.single('code'), (req, res) => {
    const Codename = req.file.originalname
    res.send({
        msg:'上传成功',
        Codename
    })
    
})

module.exports = router;