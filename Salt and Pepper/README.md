Salt and Pepper

Для решения данной задачи был изучен медианный фильтр. Суть алгоритма медианного фильтра заключается в том, что значения интенсивности каждого пикселя, находящегося в заданном окне, сортируются в порядке возрастания, после чего выбирают значение, находящееся в середине отсортированного списка, и заменяют им центральный пиксель. Таким образом и была сделана медианная фильтрация. Функция MedianFilter использовалась как реализация программы на CPU, а расчет на GPU проводился на ядре (был предоставлен доступ к серверу преподавателя). Основной код содержится в файле startGPU.cu с комментариями. Сам шум "Соль и перец" генерировался на питоне в файлике SAPNoise.ipynb.

Также для данной программы на CUDA была использована текстурная память. Были написаны обработчики событий для подсчета времени вычислений.

Данная программа работает на изображениях с размером 256х256, 512х512 и 1024х1024, с более большим разрешением программа не тестировалась в виду долгого расчета на картинке 1024х1024. На размерах изображения 128х128 и 64х64 программа выдает вот такую ошибку о том, что размер картинки очень мал и невозможно выделить память для расчета:

![3](https://user-images.githubusercontent.com/70959898/208242948-84061c1e-330e-484e-96e8-c11a7e6352b0.PNG)

Вот выводы по расчету изображений с размером 256х256, 512х512 и 1024х1024:

![2](https://user-images.githubusercontent.com/70959898/208243022-b2336f21-76e9-4e5d-880e-6438cc4a056a.PNG)
![5](https://user-images.githubusercontent.com/70959898/208243033-1a8aaa31-d28b-47e9-93e2-d7c043f9262f.PNG)
![Снимок](https://user-images.githubusercontent.com/70959898/208243039-662041ed-2440-42db-8616-bb43ceba6cdd.PNG)

Выходные изображения при расчете на CPU и на GPU с размером 256х256, 512х512 и 1024х1024 есть в репозитории.

Также была попытка работы с прямоугольным изображением, расчет на CPU дал свой результат, а при вычислении на GPU на картинке появляется эффект наложения. Картинки данного результата также есть в репозитории.

Время расчета и ускорение:

![изображение](https://user-images.githubusercontent.com/70959898/208243397-1533f9f9-317b-42d4-9fe7-e8e7b2fe13a4.png)

Графики результатов:

![изображение](https://user-images.githubusercontent.com/70959898/208244018-ee156ec9-80ab-4359-823d-d79358aa1b17.png)
![изображение](https://user-images.githubusercontent.com/70959898/208244277-d58a13ee-ef4e-43f9-803e-58c0197184c3.png)

Вывод: как видно из графиков, время вычисления на CPU для картинки в 1024х1024 существенно. Использование GPU на таких картинках просто необходимо, плюс расчета на GPU в том, что каждый пиксель расчитывается отдельной нитью.
