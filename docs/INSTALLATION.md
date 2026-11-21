# WSL (Ubuntu-26.04) va Fish shell muhitida Chirpy Jekyll loyihasini xatosiz ishga tushirish uchun quyidagi bosqichma-bosqich ko'rsatmalarga amal qiling.

1. **Tizim paketlari, Ruby va Node.js ni o'rnatish:** Zarur dasturiy ta'minotlarni apt orqali tekshirish va o'rnatish.
Ubuntu paketlar menejeri orqali Ruby, kompilyatsiya vositalari (`build-essential`) va JavaScript ishlovchisi sifatida Node.js ni o'rnatamiz:

```fish
sudo apt update
sudo apt install -y ruby-full ruby-dev build-essential nodejs npm

```

O'rnatish muvaffaqiyatli bo'lganini tekshirish uchun quyidagilarni kiriting:

```fish
ruby -v
bundler -v
node -v

```


2. **Fish shell uchun Bundler va PATH sozlamalari:** Ruxsatlar (permission) muammosining oldini olish.
Global gem'lar bilan bog'liq xatolarga duch kelmaslik uchun Bundler'ni to'g'ridan-to'g'ri loyiha papkasi ichiga (`vendor/bundle`) o'rnatishga sozlaymiz.

Fish shell'da lokal yo'lni sozlash uchun:

```fish
bundle config set --local path 'vendor/bundle'

```

Shuningdek, agar kelgusida gem'lar foydalanuvchi katalogiga tushsa, ularning `bin` papkasini Fish shell'ning `PATH` o'zgaruvchisiga qo'shib qo'yamiz (`set -gx` yordamida):

```fish
if test -d (ruby -rubygems -e 'print Gem.user_dir')/bin
    set -gx PATH $PATH (ruby -rubygems -e 'print Gem.user_dir')/bin
end

```


3. **Loyiha bog'liqliklarini (dependencies) o'rnatish:** Gemfile va Gemfile.lock bo'yicha paketlarni yuklab olish.
VS Code ichida ochilgan Chirpy loyihangiz papkasida turganingizga ishonch hosil qiling va quyidagi buyruqni bajaring:

```fish
bundle install

```

*Eslatma:* Agar `jekyll-chirpy` gemi yoki boshqa paketlarda xatolik chiqsa, avval `bundle update` qilib ko'rish tavsiya etiladi.


4. **Lokal serverni ishga tushirish:** Saytni brauzerda ko'rish.
Barcha qadamlar muvaffaqiyatli yakunlangach, Jekyll serverini ishga tushiring:

```fish
bundle exec jekyll serve

```

Server ishga tushgach, terminalda quyidagiga o'xshash xabar chiqadi:

> Server address: [http://127.0.0.1:4000/](https://www.google.com/search?q=http://127.0.0.1:4000/)

Ushbu havolani (yoki WSL IP manzilini) brauzerda ochib, saytingizni tekshirishingiz mumkin. Agar manba kodlar o'zgarganda avtomatik yangilanishi va draft'lar ham ko'rinishi kerak bo'lsa, quyidagicha kengaytirilgan holda yoqing:

```fish
bundle exec jekyll serve --livereload --drafts

```

# Eski kesh va build natijalarini tozalash
bundle exec jekyll clean

# Lokal serverni livereload va aniq host manzili bilan ishga tushirish
bundle exec jekyll s -l -H 127.0.0.1