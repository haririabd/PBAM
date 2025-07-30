from django.shortcuts import render
from django.contrib import messages
from django.template.loader import render_to_string
from django.http import HttpResponse
from django.templatetags.static import static
from django.conf import settings
import os
from weasyprint import HTML
from . import forms

# Create your views here.
def certificateForm(request):
    page_title = 'Sijil Keahlian'
    html_template = 'sijilahli.html'
    m = ''
    
    if request.method == 'POST':
        form = forms.certificateForm(request.POST)
        if form.is_valid():
            m = messages.success(request, 'Info sent successfully!')
        else:
            print(form.errors.as_text)
            m = messages.error(request, 'Error in form data!')
    else:
        form = forms.certificateForm()
    
    context = {
        "message": m,
        "page_title": page_title,
        "form": form
    }
    return render(request, html_template, context)

def generate_pdf(request):
    bg_path = os.path.join(settings.STATICFILES_BASE_DIR, 'imgs', 'sijil_pbam_design02.png')
    bg_url = f'file://{bg_path}'
    sig_path = os.path.join(settings.STATICFILES_BASE_DIR, 'imgs', 'alex_sig.png')
    sig_url = f'file://{sig_path}'

    if request.method == 'POST':
        name = request.POST.get('name')

        html_string = render_to_string('report.html', {
            'name': name,
            'background_image': bg_url,
            'sig_image': sig_url,
        })

        pdf_file = HTML(string=html_string).write_pdf()
        response = HttpResponse(pdf_file, content_type='application/pdf')
        response['Content-Disposition'] = f'filename="{name}_report.pdf"'
        return response
    else:
        return HttpResponse("Invalid method", status=405)

