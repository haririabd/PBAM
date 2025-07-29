from django.shortcuts import render

# Create your views here.
def generate_cert(request, *args, **kwargs):
    page_title = 'Sijil Keahlian'
    html_template = 'sijilahli.html'

    context = {
        "page_title": page_title,
    }
    return render(request, html_template, context)