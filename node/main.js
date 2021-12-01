const express = require('express');
const cors=require('cors')


const app = express();

app.use(cors())
app.use(express.json())
app.use(express.urlencoded({ extended: true }))


app.use('/api/results',require('./router/results'))
app.use('/api/upload',require('./router/upload'));

app.listen(5000, () => {
    console.log('启动成功');
})