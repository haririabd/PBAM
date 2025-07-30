from django import forms

class certificateForm(forms.Form):
    name = forms.CharField(label="Your name", max_length=100)