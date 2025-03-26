Özellikler:
	•	Değişkenler: Kullanıcılar değişkenlere değer atayabilir.
	•	Aritmetik İşlemler: Toplama, çıkarma, çarpma ve bölme işlemleri yapılabilir.
	•	Parantezli İfadeler: Kullanıcılar parantezli ifadeler yazabilir.
	•	Hata Yönetimi: Bölme işlemi sırasında sıfıra bölme hatası yönetilmektedir.

Gereksinimler: Racket

Çalıştırma: calculator.rkt dosyasını Racket ortamında açın ve runlayın

Projede çeşitli testler mevcuttur. Testler, temel aritmetik işlemlerinin ve değişken atamalarının doğruluğunu kontrol eder. Testlerin çıktıları terminalde görüntülenir.
	•	Değişken ataması: (assign 'x (+ 2 3))
	•	Toplama: (calculator-eval '(+ 2 3))
	•	Çıkarma: (calculator-eval '(- 5 2))
	•	Çarpma: (calculator-eval '(* 4 3))
	•	Bölme: (calculator-eval '(/ 10 2))
