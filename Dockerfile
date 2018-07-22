FROM registry.cn-shenzhen.aliyuncs.com/bookoco/bookoco-base:latest

# 将程序拷贝进去
COPY . /www/BookStack/

# 将zoneinfo.zip拷贝进去
COPY lib/time/zoneinfo.zip /usr/local/go/lib/time/

RUN chmod 0777 -R /www/BookStack/

WORKDIR /www/BookStack/

CMD [ "./BookStack" ]