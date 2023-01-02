const userService = require("../services/users.service");
const { compareSync } = require("bcrypt");
const authUtils = require('../utils/auth.utils');
const {logging} = require('../utils/logging');

// Function to handle login request
const login = async (req, res, next) => {
    // Check if email is provided in request body
    if (!req.body.email) {
        res.status(400).send({ message: "please enter an email" });
    }
    try {
        // Get user by email
        const userResponse = await userService.getUserByEmail(req.body.email);
        // Check if user exists
        if (!userResponse) {
            res.status(403).send({ message: "Invalid Credentials" });
        }
        // Check if password is valid
        const isValidPassword = compareSync(req.body.password, userResponse.password);
        if (!isValidPassword || userResponse.status !== 1) {
            res.status(403).send({ message: "Invalid Credentials" });
        }
        // Generate and send JWT token
        res.send(authUtils.generateToken(userResponse));
    } catch (error) {
        logging('error', error.message, module.id)
        res.status(400).send({ message: "Something went wrong", trace : process.env.APP_ENV != 'prod' ? error.stack : "Cannot trace the error, Please find the log"});
    }
};

// Function to get current logged in user
const getCurrentUser = async (req, res, next) => {
    try {
        // Get user by id from JWT token
        const userResponse = await userService.getUserById(req.tokenData.id);
        // Check if user exists
        if (!userResponse) {
            res.status(404).send({ message: "Something wrong with logged in user" });
        }
        res.send(userResponse);
    } catch (error) {
        // return bad request
        res.status(400).send({ message: "Something went wrong" });
    }
};

// Function to refresh JWT token
const refreshToken = async (req, res, next) => {
    try {
        // Get user by email from JWT token
        const userResponse = await userService.getUserByEmail(req.tokenData.email);
        // Check if user exists
        if (!userResponse || userResponse.status !== 1) {
            res.status(404).send({ message: "Something wrong with logged in user" });
        }
        // Generate and send new JWT token
        res.send(authUtils.generateToken(userResponse));
    } catch (error) {
        // return bad request
        res.status(400).send({ message: "Something went wrong" });
    }
};

module.exports = { login, getCurrentUser, refreshToken };
