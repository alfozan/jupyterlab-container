FROM alfozan/spark:latest

LABEL maintainer="Abdul Alfozan https://github.com/alfozan"
LABEL description="JupyterLab with JupyterHub integration and PySpark 2.3 kernel"

# install jupyterlab (aka the notebook)
RUN pip3 install jupyterlab
# install additonal python packages
RUN pip3 install pandas matplotlib numpy scipy boto3

# install common tools
RUN apt-get update && apt-get install -y git curl wget zip iputils-ping dnsutils netcat-openbsd nano bash-completion

# jupyterhub integration
# https://github.com/jupyterhub/jupyterlab-hub
RUN pip3 install jupyterhub
RUN apt-get update && apt-get install -y nodejs npm
RUN jupyter labextension install @jupyterlab/hub-extension
# clean up
RUN apt-get remove --purge -y nodejs npm && apt-get autoremove -y

# add PySpark kernel
ADD pyspark /usr/local/share/jupyter/kernels/pyspark

# set environment variables
ENV SPARK_HOME=/spark
ENV PATH="${PATH}:${SPARK_HOME}/bin:/usr/local/bin"
ENV PYSPARK_PYTHON=python3
ENV PYTHONIOENCODING=UTF-8

CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--LabApp.token=''"]
