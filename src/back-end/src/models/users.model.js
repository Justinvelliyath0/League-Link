const { DataTypes } = require('sequelize');
const sequelize = require('../config/db.config');


//create a sequelize model for user
const User = sequelize.define('users', {
    id: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        unique: true,
        primaryKey: true,
    },
    name: {
        type: DataTypes.STRING,
        allowNull: false
    },
    email: {
        type: DataTypes.STRING,
        allowNull: false
    },
    password: {
        type: DataTypes.STRING,
        allowNull: false
    },
    status: {
        type: DataTypes.INTEGER,
        allowNull: false
    },
    created_at: {
        type: DataTypes.DATE,
        allowNull: false
    },
    updated_at: {
        type: DataTypes.DATE,
        allowNull: false
    }
}, {
    tableName: 'users',
    createdAt: 'created_at',
    updatedAt: 'updated_at',
    freezeTableName : true,
    underscored : true
});

module.exports = User;