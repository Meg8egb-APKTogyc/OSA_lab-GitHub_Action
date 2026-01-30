FROM alpine:3.19 AS builder

RUN apk add --no-cache openjdk17 maven

WORKDIR /app
COPY pom.xml .
COPY src ./src

RUN mvn clean package -DskipTests

FROM alpine:3.19

LABEL maintainer="Мордакин Антон"
LABEL description="ShopAPI - Java"

RUN apk add --no-cache openjdk17-jre-headless tzdata && \
    addgroup -S appgroup && \
    adduser -S appuser -G appgroup

ENV ENVIRONMENT="stage"
ENV TZ=Europe/Moscow

WORKDIR /app

COPY --from=builder /app/target/*.jar app.jar

RUN chown -R appuser:appgroup /app

USER appuser

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
