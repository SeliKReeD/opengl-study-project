#version 330 core
struct Material {
    sampler2D diffuse;
    sampler2D specular;
    float shininess;
};

struct Light {
    vec3 position;

    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
};


out vec4 fragColor;

uniform Material material;
uniform Light light;
uniform vec3 objectColor;
uniform vec3 lightColor;

uniform vec3 viewPos;

in vec3 normal;
in vec3 fragPos;
in vec2 texCoords;

void main()
{
    vec3 norm = normalize(normal);
    vec3 lightDir = normalize(light.position - fragPos);
    float diff = max(dot(norm, lightDir), 0.0);

    vec3 viewDir = normalize(viewPos - fragPos);
    vec3 reflectDir = reflect(-lightDir, norm);  
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), material.shininess);

    vec3 ambient  = light.ambient  * vec3(texture(material.diffuse, texCoords));
    vec3 diffuse  = light.diffuse  * diff * vec3(texture(material.diffuse, texCoords));  
    vec3 specular = light.specular * spec * vec3(texture(material.specular, texCoords));
    fragColor = vec4(ambient + diffuse + specular, 1.0);   
}