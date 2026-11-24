import http from 'k6/http';
import { check, sleep } from 'k6';
import { baseUrl, scenarios } from '../config.js';
import { thresholds } from '../thresholds.js';

export const options = {
  thresholds,
  scenarios: {
    error: scenarios.error,
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
  const res = http.post(`${baseUrl}/payment/?scenario=server_error`, JSON.stringify(payload), {
    headers: { 'Content-Type': 'application/json' },
  });
  check(res, { 'server error handled': (r) => r.status === 500 });
  sleep(0.1);
}
