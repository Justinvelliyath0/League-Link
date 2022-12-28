const AWS = require('aws-sdk');
const { BadRequest } = require('../utils/errors.utils');

// Create an S3 client instance
const s3 = new AWS.S3({
    accessKeyId: process.env.AWS_ACCESS_KEY,
    secretAccessKey: process.env.AWS_SECRET_KEY,
    signatureVersion: 'v4',
    region: 'us-east-2',
});

// Middleware function to handle file uploads to S3
const uploadToS3 = async (req, res, next) => {
    // Set a default value for the image_url field in the request body
    req.body.image_url = "data.Key";

    // If a file was not included in the request, continue to the next middleware function
    if (!req.file) {
        return next();
    }

    // Set up the parameters for the S3 upload
    const uploadParams = {
        Bucket: process.env.S3_BUCKET,
        Key: `uploads${req.originalUrl}/${Date.now()}.jpg`,
        Body: req.file.buffer,
    };

    try {
        // Perform the upload to S3
        const data = await s3.upload(uploadParams).promise();

        // Update the image_url field in the request body with the S3 key of the uploaded file
        req.body.image_url = data.Key;
    } catch (err) {
        // If the upload fails, throw a BadRequest error
        throw new BadRequest(err, 400);
    }

    // Continue to the next middleware function
    next();
};

// Function to get a signed URL for a file in S3
const getSignedUrl = async (key) => {
    try {
        // Get the signed URL for the specified S3 key
        const url = await s3.getSignedUrl('getObject', {
            Bucket: process.env.S3_BUCKET,
            Key: key,
            Expires: parseInt(process.env.PRESIGNED_LINK_EXPIRE),
        })
        return url;
    } catch (err) {
        // If there is an error, log it and return null
        console.error(err);
        return null;
    }
};

module.exports = { uploadToS3, getSignedUrl };