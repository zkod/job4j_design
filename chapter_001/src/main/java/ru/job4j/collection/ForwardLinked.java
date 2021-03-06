package ru.job4j.collection;

import java.util.Iterator;
import java.util.NoSuchElementException;

/**
 * Связаное хранилище.
 *
 * @param <T> Ссылоочный тип.
 */
public class ForwardLinked<T> implements Iterable<T> {
    private Node<T> head;

    public void add(T value) {
        Node<T> node = new Node<T>(value, null);
        if (head == null) {
            head = node;
            return;
        }
        Node<T> tail = head;
        while (tail.next != null) {
            tail = tail.next;
        }
        tail.next = node;
    }

    /**
     * Удаление первого элемента.
     */
    public void deleteFirst() {
        if (head == null) {
            throw new NoSuchElementException();
        }
        head = head.next;
    }

    /**
     * Удаляем последний элемент.
     */
    public T deleteLast() {
        T elem = null;
        if (head == null) {
            throw new NoSuchElementException();
        }
        if (head.next == null) {
            elem = head.value;
            head = null;
        } else {
            var tail = head;
            while (tail.next.next != null) {
                tail = tail.next;
            }
            elem = tail.next.value;
            tail.next = null;
        }
        return elem;
    }

    /**
     * Переворачиваем односвязный список.
     */
    public void revert() {
        Node<T> revert = null;
        for (T value : this) {
            revert = new Node<>(value, revert);
        }
        head = revert;
    }

    @Override
    public Iterator<T> iterator() {
        return new Iterator<T>() {
            Node<T> node = head;

            @Override
            public boolean hasNext() {
                return node != null;
            }

            @Override
            public T next() {
                if (!hasNext()) {
                    throw new NoSuchElementException();
                }
                T value = node.value;
                node = node.next;
                return value;
            }
        };
    }

    private static class Node<T> {
        T value;
        Node<T> next;

        public Node(T value, Node<T> next) {
            this.value = value;
            this.next = next;
        }
    }
}
