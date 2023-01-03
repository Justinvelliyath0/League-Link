const {apiLogger} = require('../utils/logging');

const apiLog = (req, res, next) => {
    console.log(req.ip);
    console.log(req);
    const getValue = (part, o) => Object.entries(o).find(([k, v]) => k.startsWith(part))?.[1]
    apiLogger.log('info',`[New Request] User Agent: ${getValue('user-agent', req.headers)} Request IP: ${req.ip} Request URL: ${req.originalUrl} Request Method: ${req.method} Query Params: ${JSON.stringify(req.query)}`,
    'New Request');
    next();
}

module.exports = apiLog