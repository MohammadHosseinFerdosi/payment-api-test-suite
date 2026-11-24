import http from 'k6/http';
import { check, sleep } from 'k6';
import { baseUrl } from '../config.js';
import { thresholds } from '../thresholds.js';

export const options = {
  thresholds: {
    ...thresholds,
    http_req_failed: ['rate<0.001'],
  },
  scenarios: {
    validation: {
      executor: 'ramping-vus',
      startVUs: 1,
      stages: [{ duration: '10s', target: 20 }, { duration: '20s', target: 50 }],
      gracefulRampDown: '5s',
    },
  },
};

export default function () {
  const payload = {
    options: [{
      type: 'card',
      title: 'Credit Card',
      is_clickable: true,
      is_active: true,
      credit: 100,
      is_default: true,
      price_type: 'fixed',
    }],
  };
  const res = http.post(`${baseUrl}/validate/`, JSON.stringify(payload), {
    headers: { 'Content-Type': 'application/json' },
  });
  check(res, { 'validation success': (r) => r.status === 200 });
  sleep(0.1);
}
