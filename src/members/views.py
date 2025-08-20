from django.shortcuts import render
from django.contrib.auth.decorators import login_required

# profile detail is the view of current user of his own profile.
# No need for specific link. Can be /profile
@login_required
def user_profile_detail(request, *args, **kwargs):
    page_title = 'Profile'
    html_template = 'profile/profile-base.html'
    current_user = request.user
    is_me = current_user

    context = {
        "profile_page": 'active',
        "page_title": page_title,
        "owner": is_me,
    }
    return render(request, html_template, context)

# if a member is also an AJK, this is the public view of each portfolio profile.
# Example - YDP, S/U, Bendahari. Need to have specific link /ydp, /tydp etc.
def profile_ajk():
    pass