import http from 'k6/http';
import { sleep } from 'k6';

// Read the API path from an environment variable
const API_PATH = __ENV.API_PATH;
const BASE_URL = 'https://<API_GATEWAY_ID>.execute-api.<REGION>.amazonaws.com';
const API_URL = BASE_URL + API_PATH;

// Define the options for the load test
export let options = {
    duration: '10m',
    vus: 990, // Number of Virtual Users
    iterations: 1000000, // Total number of requests
};

export default function () {
    // Send a GET request to the API
    http.get(API_URL);

    // Optional: Add a small sleep to simulate real-world usage
    sleep(0.2);
}