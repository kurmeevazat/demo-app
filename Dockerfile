# Используем официальный образ Maven для сборки приложения
FROM maven:3.8.7-openjdk-18 AS build

# Устанавливаем рабочий каталог и копируем только необходимые файлы для уменьшения контекста сборки
WORKDIR /opt/demo-app
COPY pom.xml .
COPY src ./src

# Выполняем сборку проекта
RUN mvn clean package

# Используем минимальный образ для запуска приложения
FROM openjdk:18-jdk-slim

# Устанавливаем переменную окружения для указания рабочего каталога
WORKDIR /opt/demo-app

# Копируем скомпилированный JAR файл из предыдущего этапа
COPY --from=build /opt/demo-app/target/*.jar ./demo-app.jar

# Устанавливаем команду по умолчанию для запуска приложения
CMD ["java", "-jar", "demo-app.jar"]