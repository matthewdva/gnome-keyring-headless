Name:		gnome-keyring-headless
Version:	0.0.1
%{?autorelease:Release: %{autorelease}}
%{!?autorelease:Release: 1%{?dist}}
Summary:	Provides configuration helper script for gnome-keyring headless
License:	GPL-3.0-or-later
Group:		System/Authentication
URL:		https://github.com/matthewdva/%{name}
Source:		%{url}/archive/%{version}/%{name}-%{version}.tar.gz
BuildArch:	noarch
Requires:	gnome-keyring-pam
Requires:	dbus

%if 0%{?fedora} || 0%{?rhel} > 7
Requires:	authselect
Requires:	patch
%endif

%if 0%{?_suse_version} >= 1500
Requires:	pam-config
%endif

%description
Provides help scripts for configuring and enabling gnome-keyring on a headless
system.  The scripts will assist in:
  - enable/disable pam_gnome_keyring.
  - launching dbus when not in a GUI session
  - locks the keyring on logout

%prep
%autosetup

%build
# N/A

%install
%__install -Dm0555 src/shared-dbus-launcher.sh %{buildroot}%{_sysconfdir}/profile.d/shared-dbus-launcher.sh
%__install -Dm0555 src/lock_gnome_keyring.sh %{buildroot}%{_sysconfdir}/profile.d/logout.d/lock_gnome_keyring.sh
%__install -Dm0500 src/gnome-keyring-pam-setup %{buildroot}%{_datadir}/%{name}/gnome-keyring-pam-setup

%check
# N/A

%post
[ $1 == 1 ] && %{_datadir}/%{name}/gnome-keyring-pam-setup install

%preun
[ $1 == 0 ] && %{_datadir}/%{name}/gnome-keyring-pam-setup uninstall

%files
%{_sysconfdir}/profile.d/shared-dbus-launcher.sh
%{_sysconfdir}/profile.d/logout.d/lock_gnome_keyring.sh
%{_datadir}/%{name}/gnome-keyring-pam-setup

%changelog
%{?autochanglog}
