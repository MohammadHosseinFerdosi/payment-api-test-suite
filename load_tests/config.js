export const baseUrl = 'http://127.0.0.1:8000';
export const scenarios = {
  happy: {
    executor: 'ramping-vus',
    startVUs: 1,
    stages: [{ duration: '10s', target: 20 }, { duration: '20s', target: 50 }],
    gracefulRampDown: '5s',
  },
  error: {
    executor: 'ramping-vus',
    startVUs: 1,
    stages: [{ duration: '10s', target: 20 }, { duration: '20s', target: 50 }],
    gracefulRampDown: '5s',
  },
};
