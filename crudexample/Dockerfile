FROM python:3.8.10
COPY requirements.txt ./
RUN pip3 install --user -r requirements.txt
COPY . ./
RUN chmod +x docker_run_server.sh
EXPOSE 80
ENTRYPOINT ["./docker_run_server.sh"]
