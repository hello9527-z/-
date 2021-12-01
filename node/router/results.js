const express = require('express');

const router = express.Router();
const fs = require('fs');
const path = require('path');

const childProcess = require('child_process');

const dir = path.resolve(__dirname, 'C:/');

router.post('/',(req,res)=>{
    lang=req.body.lang
    filename=req.body.filename
    codename=req.body.codename
    inputName=req.body.inputName
    const res1 = childProcess.execSync(`${lang} C:/${codename} C:/${filename}`, (error, stdout, stderr) => {
        if (error) {
            console.log(error)
        }
    });
    const file = path.resolve(__dirname, `C:/${inputName}`);
    const rs = fs.createReadStream(file, {
        encoding: 'utf-8',
    });
    const resultsArr = [];
    rs.on('data', (chunk) =>{
        const chunkArr = chunk.split(/[\r\n]+/g);
        chunkArr.splice(chunkArr.length-1,1)
        chunkArr.forEach((ele, index) => {
            const arr = ele.split(/\t+/g);
            if (arr[arr.length-1]=='') {
                arr.splice(arr.length-1,1)
            }
            resultsArr.push(arr)
        })
    })
    rs.on('end', () => {
        res.send({
            msg:'ok',
            resultsArr
        });
    })
})
module.exports = router;