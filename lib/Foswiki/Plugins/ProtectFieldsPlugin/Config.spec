# ---+ Extensions
# ---++ ProtectFieldsPlugin

# **PERL**
# Hash of conditions mapped to field names.<br/>
# Expanding the condition must lead to perl false/true.<br/>
# Example: <pre>{'TopicTitle' => "%IF{"$WEB allows 'CHANGETITLE'" then="1" else="0"}%"}</pre>
$Foswiki::cfg{Plugins}{ProtectFieldsPlugin}{ProtectedFieldsAllWebs} = {};

# **PERL**
# Hash of conditions mapped to field names.<br/>
# Expanding the condition must lead to perl false/true.<br/>
# Example: <pre>{'TopicTitle' => {'MyWeb' => "%IF{"$WEB allows 'CHANGETITLE'" then="1" else="0"}%"}}</pre>
$Foswiki::cfg{Plugins}{ProtectFieldsPlugin}{ProtectedFields} = {};
