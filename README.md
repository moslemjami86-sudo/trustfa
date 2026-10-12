# تراست‌فا — Python + PostgreSQL + Tailwind

| لایه | تکنولوژی |
|------|-----------|
| فرانت | HTML5 + Tailwind CSS + JavaScript |
| بک‌اند | FastAPI + SQLAlchemy |
| دیتابیس | PostgreSQL (یا SQLite محلی) |
| ورود | ایمیل/رمز + **Google OAuth واقعی** |
| مدیریت | **پنل ادمین** |

---

## ۱) اجرای محلی

```bash
cd trustfa-py/backend
pip install -r requirements.txt
uvicorn main:app --host 0.0.0.0 --port 8000
```

http://localhost:8000

با Postgres:

```bash
export DATABASE_URL="postgresql+psycopg2://trustfa:trustfa@localhost:5432/trustfa"
export ADMIN_EMAILS="you@gmail.com"
export GOOGLE_CLIENT_ID="xxx.apps.googleusercontent.com"
uvicorn main:app --port 8000
```

یا: `docker compose up --build`

---

## ۲) دیپلوی آنلاین (برای استفاده دیگران)

### گزینه A — Render (رایگان مناسب شروع)

1. کد را در GitHub بگذارید  
2. [Render](https://render.com) → New → Blueprint → همین ریپو  
3. فایل `render.yaml` خودکار Postgres + وب‌سرویس می‌سازد  
4. در Environment این‌ها را پر کنید:
   - `GOOGLE_CLIENT_ID`
   - `ADMIN_EMAILS=ایمیل-شما@gmail.com`
5. بعد از Deploy، آدرس مثل `https://trustfa.onrender.com` می‌گیرید

**نکته Render:** روی پلن رایگان بعد از بی‌استفادگی sleep می‌شود؛ اولین درخواست ممکن است ۳۰–۶۰ ثانیه طول بکشد.

### گزینه B — Railway

1. [Railway](https://railway.app) → New Project → Deploy from GitHub  
2. سرویس Postgres اضافه کنید  
3. متغیرها:
   - `DATABASE_URL` (از پلاگین Postgres)
   - `SECRET_KEY`
   - `GOOGLE_CLIENT_ID`
   - `ADMIN_EMAILS`
4. Start: `uvicorn main:app --host 0.0.0.0 --port $PORT` (workdir: backend)

### گزینه C — VPS (ارزان دائمی)

```bash
git clone ...
cd trustfa-py
docker compose up -d --build
# یا nginx + uvicorn + postgres
```

دامنه را به IP سرور بزنید و با Caddy/Nginx HTTPS بگیرید.

---

## ۳) ورود واقعی گوگل

1. [Google Cloud Console](https://console.cloud.google.com/) → پروژه جدید  
2. APIs & Services → OAuth consent screen → External → ذخیره  
3. Credentials → Create Credentials → OAuth client ID → **Web application**  
4. **Authorized JavaScript origins**:
   - `http://localhost:8000`
   - `https://YOUR-DOMAIN.com`
5. Client ID را کپی کنید → `GOOGLE_CLIENT_ID` در سرور  
6. رفرش سایت → دکمه رسمی «Continue with Google» ظاهر می‌شود

بک‌اند توکن را با `google-auth` تأیید می‌کند (`POST /api/auth/google/token`).

---

## ۴) پنل ادمین

- ایمیل‌های داخل `ADMIN_EMAILS` هنگام ثبت‌نام/ورود گوگل **ادمین** می‌شوند  
- بعد از ورود، از منوی سه‌خط → **پنل ادمین**  
- امکانات:
  - آمار کاربران / نظرات / گزارش‌ها  
  - مخفی یا حذف نظر  
  - تأیید کسب‌وکار  
  - ارتقا/لغو ادمین کاربران  
  - مشاهده پیام‌های تماس و گزارش‌ها  

---

## API مهم

| مسیر | توضیح |
|------|--------|
| `GET /api/config` | `googleClientId` برای فرانت |
| `POST /api/auth/google/token` | ورود واقعی گوگل |
| `GET /api/admin/stats` | آمار (ادمین) |
| `GET /api/admin/reviews` | همه نظرات |
| `PATCH /api/admin/reviews/{id}/hide` | مخفی/نمایش |
| `DELETE /api/admin/reviews/{id}` | حذف |
| `GET /api/admin/users` | کاربران |
| `PATCH /api/admin/users/{id}/admin` | تغییر نقش |
| `PATCH /api/admin/businesses/{id}/verify` | تأیید کسب‌وکار |

---

## موبایل

بعد از دیپلوی، لینک HTTPS را در گوشی باز کنید — همه چیز کار می‌کند.
