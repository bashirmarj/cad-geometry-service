FROM continuumio/miniconda3:latest

WORKDIR /app

# Install Python and pythonocc-core from conda-forge
RUN conda install -c conda-forge python=3.11 pythonocc-core=7.7.2 flask flask-cors gunicorn numpy -y && \
    conda clean -afy

COPY app.py .

EXPOSE 5000

# Run Flask app using gunicorn
CMD ["bash", "-c", "gunicorn --bind 0.0.0.0:${PORT:-5000} --workers 2 app:app"]