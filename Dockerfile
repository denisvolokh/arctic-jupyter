FROM ubuntu:latest

RUN apt-get update -y
RUN apt-get install -y git python-pip python-dev build-essential curl libcurl4-openssl-dev python-matplotlib libblas-dev liblapack-dev libatlas-base-dev gfortran

# Install Tini
RUN curl -L https://github.com/krallin/tini/releases/download/v0.6.0/tini > tini && \
    echo "d5ed732199c36a1189320e6c4859f0169e950692f451c03e7854243b95f4234b *tini" | sha256sum -c - && \
    mv tini /usr/local/bin/tini && \
    chmod +x /usr/local/bin/tini

# Move notebook contents into place.
#ADD . /usr/src/jupyter-notebook

RUN pip install jupyter

# Add a notebook profile.
RUN mkdir -p -m 700 /root/.jupyter/ && \
    echo "c.NotebookApp.ip = '*'" >> /root/.jupyter/jupyter_notebook_config.py

RUN pip install git+https://github.com/manahl/arctic.git Quandl ystockquote

VOLUME /notebooks
WORKDIR /notebooks

EXPOSE 8888

ENTRYPOINT ["tini", "--"]
CMD ["jupyter", "notebook"]
