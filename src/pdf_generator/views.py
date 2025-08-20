from django.shortcuts import render
from . import forms

# Create your views here.
def formSijilKeahlian(request):
    m = ''
    
    if request.method == 'POST':
        form = forms.sijilKeahlianForm(request.POST)
        if form.is_valid():
            m = messages.success(request, 'Info sent successfully!')
        else:
            print(form.errors.as_text)
            m = messages.error(request, 'Error in form data!')
    else:
        form = forms.sijilKeahlianForm()
    
    context = {
        "message": m,
        "form": form,
        "sijil_page": 'active',
    }
    return render(request, html_template, context)