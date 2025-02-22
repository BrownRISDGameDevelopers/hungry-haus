using UnityEngine;

public class PlayerInteractionTrigger : MonoBehaviour
{
    const float maxDistance = 2f;
    const float interactLayerMask = 6;
    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.E))
        {
            RaycastHit hit;
            Vector3 facing = transform.forward;
            if (Physics.Raycast(transform.position, facing, out hit, maxDistance))
            {
                hit.collider.gameObject.GetComponent<InteractableObject>().Interact();
            }
        }
    }
}
