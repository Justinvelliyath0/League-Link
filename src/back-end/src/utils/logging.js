const { createLogger, format, transports } = require('winston');

// Destructuring assignment to get the required functions from the format object
const { combine, timestamp, label, printf } = format;

// Custom format for the logger output
const logFormat = printf(({ level, message, label, timestamp }) => {
  return `${level.toUpperCase()} :: ${timestamp} message: ${message} file : [${label}]`;
});

// Custom format for the API logger output
const apiLogFormat = printf(({ level, message, label, timestamp }) => {
  return `${level.toUpperCase()} :: ${timestamp} ${message} file : [${label}]`;
});

// Create a logger with a custom format and file transport
const logger = createLogger({
  format: combine(
    timestamp(),
    logFormat
  ),
  transports: [
    new transports.File({ filename: 'logs/access.log' })
  ]
});

// Function to log a message with a custom level, message, and label
const logging = (level, message, label = '') => {
  logger.log({
    level: level,
    message: message,
    label: label
  });
};

// Create an API logger with a custom format and file transport
const apiLogger = createLogger({
  format: combine(
    timestamp(),
    apiLogFormat
  ),
  transports: [
    new transports.File({ filename: 'logs/access.log' })
  ]
});

// Export the log and apiLogger functions
module.exports = { logging, apiLogger };
