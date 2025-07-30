// supabaseClient.js
import { createClient } from 'https://cdn.jsdelivr.net/npm/@supabase/supabase-js/+esm';

// مشخصات اتصال به Supabase
const SUPABASE_URL = 'https://nkixhylasuhtgeiytebd.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5raXhoeWxhc3VodGdlaXl0ZWJkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTExNDk4NzIsImV4cCI6MTc0MjY4NTg3Mn0.m7g4jjEpT5ybhMgyBD5s44GuWuxK5TDdXIvID2TTpC0';

// ایجاد کلاینت Supabase
export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);