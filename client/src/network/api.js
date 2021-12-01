import axios from 'axios';

axios.defaults.timeout = 20000;
axios.defaults.headers.post['Content-Type'] = 'application/x-www-form-urlencoded';

export function getResults(params) {
    return axios.post('http://localhost:5000/api/results', params);
}
