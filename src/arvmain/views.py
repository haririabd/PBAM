from django.shortcuts import render

def index_view(request, *args, **kwargs):
    page_title = 'Homepage'
    html_template = 'index.html'

    context = {
        "page_title": page_title,
        "home_page": 'active',
    }
    return render(request, html_template, context)
