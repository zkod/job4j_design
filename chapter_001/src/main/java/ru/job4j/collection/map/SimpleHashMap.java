package ru.job4j.collection.map;

import java.util.ConcurrentModificationException;
import java.util.Iterator;
import java.util.NoSuchElementException;

/**
 * Реализация простой хэш-карты.
 *
 * @author Evgeny Novoselov
 */
public class SimpleHashMap<K, V> implements Iterable<V> {

    @SuppressWarnings("unchecked")
    private Node<K, V>[] table = (Node<K, V>[]) new Node[16];

    private int modCount = 0;
    private int countElements = 0;
    static final float DEFAULT_LOAD_FACTOR = 0.75f;

    /**
     * Добавляем элемент в карту.
     *
     * @param key   Ключ
     * @param value Значение
     * @return Результат добавления элемента.
     */
    public boolean insert(K key, V value) {
        boolean result = false;
        int position = getPosition(key);
        if (table[position] == null) {
            if (countElements > table.length * DEFAULT_LOAD_FACTOR) {
                resize();
            }
            modCount++;
            countElements++;
            table[position] = new Node<>(key, value);
            result = true;
        }
        return result;
    }

    private int getPosition(K key) {
        return getPosition(key, table.length);
    }

    private int getPosition(K key, int length) {
        return (length - 1) & (key.hashCode() ^ (key.hashCode() >>> 16));
    }

    private void resize() {
        @SuppressWarnings("unchecked")
        Node<K, V>[] newTable = (Node<K, V>[]) new Node[table.length * 2];
        for (Node<K, V> elem : table) {
            if (elem != null) {
                int newPosition = getPosition(elem.key, newTable.length);
                newTable[newPosition] = elem;
            }
        }
        table = newTable;
    }

    /**
     * Возвращаем значение по ключу.
     *
     * @param key Ключ.
     * @return Значение по ключу.
     */
    public V get(K key) {
        int position = getPosition(key);
        return table[position] != null && key.equals(table[position].key) ? table[position].value : null;
    }

    /**
     * Удаляем значение.
     *
     * @param key Ключ.
     * @return Результат удаления.
     */
    public boolean delete(K key) {
        boolean result = false;
        int position = getPosition(key);
        if (table[position] != null && key.equals(table[position].key)) {
            modCount++;
            countElements--;
            table[position] = null;
            result = true;
        }
        return result;
    }

    /**
     * Returns an iterator over elements of type {@code T}.
     *
     * @return an Iterator.
     */
    @Override
    public Iterator<V> iterator() {
        return new Iterator<V>() {
            private int index = -1;
            private int nextIndex = -1;
            private final int expectedModCount = modCount;

            @Override
            public boolean hasNext() {
                if (expectedModCount != modCount) {
                    throw new ConcurrentModificationException();
                }
                return index < nextIndex || index != findNext();
            }

            @Override
            public V next() {
                if (!hasNext()) {
                    throw new NoSuchElementException();
                }
                index = nextIndex;
                return table[index].value;
            }

            private int findNext() {
                for (int i = index + 1; i < table.length; i++) {
                    if (table[i] != null) {
                        nextIndex = i;
                        break;
                    }
                }
                return nextIndex;
            }
        };
    }

    private static class Node<K, V> {
        K key;
        V value;

        public Node(K key, V value) {
            this.key = key;
            this.value = value;
        }
    }
}
