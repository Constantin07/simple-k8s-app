const test = require('node:test');
const assert = require('node:assert/strict');
const request = require('supertest');

const app = require('./server');

test('GET /health returns UP and application version', async () => {
    const response = await request(app)
        .get('/health')
        .expect(200);

    assert.equal(response.body.status, 'UP');
    assert.equal(
        response.body.app_version,
        process.env.APP_VERSION || 'unknown'
    );
});

test('GET /health returns JSON', async () => {
    const response = await request(app)
        .get('/health')
        .expect('Content-Type', /json/)
        .expect(200);

    assert.deepEqual(response.body, {
        status: 'UP',
        app_version: process.env.APP_VERSION || 'unknown'
    });
});
