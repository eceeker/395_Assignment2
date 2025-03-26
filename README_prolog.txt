Özellikler:
	•	Değişkenler: Kullanıcılar değişkenlere değer atayabilir ve bu değişkenleri kullanarak işlemler yapabilir.
	•	Aritmetik İşlemler: Toplama, çıkarma, çarpma ve bölme işlemleri yapılabilir.
	•	Hata Yönetimi: 0’a bölme hatası yönetilmektedir.
	•	Parantezli İfadeler: Kullanıcılar parantezli ifadeleri işleyebilir.

Gereksinimler: SWI-Prolog

Çalıştırma: calculator.pl dosyasını Prolog ortamını başlatın (swipl komutunu kullanarak).

Projede çeşitli testler bulunmaktadır. Testler, temel aritmetik işlemlerinin ve değişken atamalarının doğruluğunu kontrol eder. Ayrıca 0’a bölme hatasını kontrol eder.
	•	Değişken ataması: assign(x, 5).
	•	Toplama: eval(add(2, 3), Result).
	•	Çıkarma: eval(sub(5, 3), Result).
	•	Çarpma: eval(mul(4, 5), Result).
	•	Bölme: eval(div(10, 2), Result).
	•	0’a bölme hatası: eval(div(10, 0), Result).
	•	parantez Kontrolü: eval_with_parentheses(add(2, 3)), 5).
